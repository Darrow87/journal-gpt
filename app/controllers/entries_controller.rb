class EntriesController < ApplicationController
    before_action :authenticate_user!
  
    def new
      @entry = current_user.entries.build
    end
  
    def create
      @entry = current_user.entries.build(entry_params)
      @entry.content = generate_chatgpt_responses(@entry.content)
  
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
        Rails.application.credentials.chatgpt[:endpoint],
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{Rails.application.credentials.chatgpt[:api_key]}"
        },
        body: {
          prompt: prompt,
          max_tokens: 500, # Adjust based on your needs
          stop: ["\n", "\n\n"], # Optional: Define stopping criteria
        }.to_json
      )
  
      if response.success?
        response_body = JSON.parse(response.body)
        # Assuming the response structure contains a 'choices' array with text responses
        response_body["choices"].first["text"].strip
      else
        # Handle error or fallback
        content # Return original content or a meaningful error message
      end
    rescue => e
      Rails.logger.error("Failed to fetch ChatGPT responses: #{e.message}")
      # Handle exception
      content # Return original content or a meaningful error message
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
  

