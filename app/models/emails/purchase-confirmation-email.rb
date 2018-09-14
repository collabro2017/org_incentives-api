require 'mustache'

class PurchaseConfirmationEmail < Mustache
  self.template_file = './app/models/emails/purchase-confirmation-email.mustache'
end