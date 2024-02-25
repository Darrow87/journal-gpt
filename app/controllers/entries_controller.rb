class EntriesController < ApplicationController
    before_action :authenticate_user!
  
    def new
      @entry = current_user.entries.build
    end
  
    def create
      @entry = current_user.entries.build(entry_params)
      @entry.content = generate_chatgpt_responses(entry_params[:content])
  
      if @entry.save
        redirect_to @entry, notice: 'Your entry has been saved successfully.'
      else
        render :new
      end
    end
  
    def show
      @entry = Entry.find(params[:id])
    end
  
    private
  
    def entry_params
      params.require(:entry).permit(:title, :date, content: {})
    end
  
    def generate_chatgpt_responses(content)
      content.transform_values do |question|
        # Here you make the API call to ChatGPT with the question
        # and return the response. This is a simplified example.
        # You would replace it with your actual ChatGPT API call.
        "Response to '#{question}' from ChatGPT"
      end
    end
  end
  