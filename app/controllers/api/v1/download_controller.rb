require "google/cloud/storage"

module Api
  module V1
    class DownloadController < ApplicationController
      include Secured

      def show
        puts "download"
        @storage = Google::Cloud::Storage.new({ project_id: 'incentives-186112', keyfile: "#{Rails.root}/incentives-531d7406fb32.json" })
        @bucket  = @storage.bucket ENV["GOOGLE_CLOUD_STORAGE_BUCKET"]
        db_file = Document.find(params[:id])
        file = @bucket.file db_file.bucket_link
        shared_url = file.signed_url method: "GET",
                                     expires: 30.minutes
        render json: { url: shared_url }, status: :ok
      end

      def download
        puts "download"
        puts params
        puts params[:id]
      end
    end
  end
end
