# lib/tasks/openai_setup.rake
require 'httparty'

namespace :openai do
  desc "Upload CBT_DBT_Trainer document to OpenAI"
  task :upload_cbt_dbt_trainer => :environment do
    file_path = Rails.root.join('lib', 'assets', 'CBT_DBT_Trainer').to_s
    purpose = "assistants" # or "fine-tune" based on your use case
    api_key = Rails.application.credentials.openai_api_key

    response = HTTParty.post(
      "https://api.openai.com/v1/files",
      headers: {
        "Authorization" => "Bearer #{api_key}",
        "Content-Type" => "multipart/form-data"
      },
      body: {
        purpose: purpose,
        file: File.new(file_path, "rb")
      }
    )

    if response.success?
      file_id = JSON.parse(response.body)["id"]
      puts "File uploaded successfully. File ID: #{file_id}"
    else
      puts "Failed to upload file: #{response.body}"
    end
  rescue => e
    puts "An error occurred: #{e.message}"
  end
end
