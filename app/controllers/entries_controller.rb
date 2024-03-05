class EntriesController < ApplicationController
    before_action :authenticate_user!
  
    def new
      @entry = current_user.entries.build
    end
  
    def create
   
      @entry = current_user.entries.build(entry_params)
      chatgpt_response = generate_chatgpt_responses(@entry.content)
    
      # Here's where you'd update the content with the ChatGPT response
      @entry.content.merge!("chatgpt_response" => chatgpt_response)
    
      if @entry.save
        redirect_to @entry, notice: 'Your entry has been saved successfully.'
      else
        render :new
      end
    end
    
 

    def show
      @entry = Entry.find(params[:id])
    end
  
    def index
      @entries = current_user.entries.order(date: :desc)
    end
  
    private
  
    def entry_params
      params.require(:entry).permit(:title, :date, content: {})
    end
  
    def generate_chatgpt_responses(content)
      prompt = generate_chatgpt_prompt(content)
      response = HTTParty.post(
        Rails.application.credentials.dig(:chatgpt, :endpoint) + "/chat/completions",
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{Rails.application.credentials.dig(:chatgpt, :api_key)}"
        },
        body: {
          model: "gpt-3.5-turbo", # Adjust model as necessary
          messages: [
            {role: "user", content: prompt}
          ]
        }.to_json
      )
      
      if response.success?
        response_body = JSON.parse(response.body)
        # Adjusted to match the actual response structure
        chatgpt_response = response_body["choices"].first["message"]["content"].strip
      else
        Rails.logger.error("ChatGPT API request failed: #{response.body}")
        nil # Return nil or a default response as a fallback
      end
      
    rescue => e
      Rails.logger.error("Failed to fetch ChatGPT responses: #{e.message}")
      nil # Return nil or a default response as a fallback
    end
    
  
    def generate_chatgpt_prompt(content)
      challenge = content["challenge"]
      feelings = content["feelings"]
      resolution = content["resolution"]
  
      prompt = <<~PROMPT
        Challenge: #{challenge}
        Feelings: #{feelings}
        Resolution: #{resolution}
        
        Based on the challenge, feelings, and resolution described above, please provide three different solutions to overcome the challenge.
      PROMPT
  
      prompt
    end
  end
  

