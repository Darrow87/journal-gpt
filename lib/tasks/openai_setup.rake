# lib/tasks/openai_setup.rake
require 'httparty'

namespace :openai do
  desc "Upload a file to OpenAI"
  task :upload_file, [:file_path, :purpose] => :environment do |t, args|
    raise ArgumentError, "File path and purpose are required" unless args[:file_path] && args[:purpose]

    file_path = args[:file_path]
    purpose = args[:purpose]
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
