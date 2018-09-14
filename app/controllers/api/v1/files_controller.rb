require "google/cloud/storage"

module Api
  module V1
    class FilesController < ApplicationController
      include SecuredAdmin


      def index
        tenant = Tenant.find(@tenant)
        render json: { data: tenant.documents.as_json(:include => :employee_documents) }, status: :ok
      end

      def create
        @storage = Google::Cloud::Storage.new({ project_id: 'incentives-186112' })
        @bucket  = @storage.bucket ENV["GOOGLE_CLOUD_STORAGE_BUCKET"]

        puts params
        tenant = Tenant.find(@tenant)
        data = params[:data]
        puts data
        file_path = data.path
        file_name = data.original_filename
        puts file_name, file_path
        file = @bucket.create_file file_path, "#{@tenant}/#{file_name}"

        puts "Name: #{file.name}"
        puts "Bucket: #{@bucket.name}"
        puts "Storage class: #{@bucket.storage_class}"
        puts "ID: #{file.id}"
        puts "Size: #{file.size} bytes"
        puts "Created: #{file.created_at}"
        puts "Updated: #{file.updated_at}"
        puts "Generation: #{file.generation}"
        puts "Metageneration: #{file.metageneration}"
        puts "Etag: #{file.etag}"
        puts "Owners: #{file.acl.owners.join ","}"
        puts "Crc32c: #{file.crc32c}"
        puts "md5_hash: #{file.md5}"
        puts "Cache-control: #{file.cache_control}"
        puts "Content-type: #{file.content_type}"
        puts "Content-disposition: #{file.content_disposition}"
        puts "Content-encoding: #{file.content_encoding}"
        puts "Content-language: #{file.content_language}"
        puts "Metadata:"
        file.metadata.each do |key, value|
          puts " - #{key} = #{value}"
        end


        # Store file metadata to db
        document = tenant.documents.create!(file_name: file_name, bucket_link: file.name)

        render json: { data: document }, status: :ok
      end
    end
  end
end
