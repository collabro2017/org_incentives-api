class DocumentService
  def initialize(tenant, user_id)
    @tenant = tenant
    @user_id = user_id
  end

  def user_documents_needs_acceptance
    employee = @tenant.employees.find_by! account_id: @user_id
    employee.employee_documents.where(requires_acceptance: true).find_each
  end

  def user_documents_all
    employee = @tenant.employees.find_by! account_id: @user_id
    employee.employee_documents.find_each
  end

  def order_documents
    employee = @tenant.employees.find_by! account_id: @user_id
    employee.order_documents
  end

  def documents_for_employee(onlyDocumentsInNeedOfAcceptance = false)
    employee_documents = onlyDocumentsInNeedOfAcceptance ? self.user_documents_needs_acceptance : self.user_documents_all

    @storage = Google::Cloud::Storage.new({ project_id: 'incentives-186112', keyfile: "#{Rails.root}#{ENV["GOOGLE_CLOUD_STORAGE_SERVICE_ACCOUNT"]}" })
    @bucket  = @storage.bucket ENV["GOOGLE_CLOUD_STORAGE_BUCKET"]

    all_employee_documents = employee_documents.map { |ed|
      doc = ed.document
      file = @bucket.file doc.bucket_link
      shared_url = file.signed_url method: "GET",
                                   expires: 60.minutes
      {
          :fileName => doc.file_name,
          :id => doc.id,
          :document_header => doc.document_header,
          :message_header => doc.message_header,
          :message_body => doc.message_body,
          :requires_acceptance => ed.requires_acceptance,
          :is_read_and_accepted => ed.is_read_and_accepted,
          :accepted_at => ed.accepted_at,
          :downloadLink => shared_url
      }
    }

    # Include Order Documents
    all_order_documents = self.order_documents.map { |od|
      doc = od.document
      file = @bucket.file doc.bucket_link
      shared_url = file.signed_url method: "GET",
                                   expires: 60.minutes
      {
          :fileName => doc.file_name,
          :id => doc.id,
          :document_header => doc.document_header,
          :message_header => doc.message_header,
          :message_body => doc.message_body,
          :requires_acceptance => false,
          :is_read_and_accepted => false,
          :accepted_at => nil,
          :downloadLink => shared_url
      }
    }


    # Include documents attached to the employees orders
    # Include shared files for tenant

    all_employee_documents.concat(all_order_documents)
  end

  def info_and_download_link_for_document(document_id)
    @storage = Google::Cloud::Storage.new({ project_id: 'incentives-186112', keyfile: "#{Rails.root}#{ENV["GOOGLE_CLOUD_STORAGE_SERVICE_ACCOUNT"]}" })
    @bucket  = @storage.bucket ENV["GOOGLE_CLOUD_STORAGE_BUCKET"]

    doc = Document.find(document_id)
    file = @bucket.file doc.bucket_link
    shared_url = file.signed_url method: "GET",
                                 expires: 60.minutes
    {
        :fileName => doc.file_name,
        :id => doc.id,
        :downloadLink => shared_url
    }
  end

  def delete_document(id)
    document = @tenant.documents.find(id)
    @storage = Google::Cloud::Storage.new({ project_id: 'incentives-186112', keyfile: "#{Rails.root}#{ENV["GOOGLE_CLOUD_STORAGE_SERVICE_ACCOUNT"]}" })
    @bucket  = @storage.bucket ENV["GOOGLE_CLOUD_STORAGE_BUCKET"]
    if document.present?
      file = @bucket.file document.bucket_link
      file.delete
      document.destroy!
    else
      false
    end
  end
end