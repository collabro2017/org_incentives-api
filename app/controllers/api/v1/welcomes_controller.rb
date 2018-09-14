module Api
  module V1
    class WelcomesController < ApplicationController
      include Secured

      def index
        tenant = Tenant.find(@tenant)
        token = TokenService.new(@token)
        token.require_role 'user'
        user_id = token.user_id
        user_awards = AwardsService.new(tenant, user_id).user_awards
        user_service = UserService.new(@token, tenant)
        employee = user_service.employee
        stock_price = tenant.stock_prices.order('date DESC, created_at DESC').first

        doc_service = DocumentService.new(tenant, user_id)
        documents = doc_service.documents_for_employee(onlyDocumentsInNeedOfAcceptance: false)

        data = {
            awards: user_awards.as_json(include: {
                vesting_events: {
                    methods: [:exercised_quantity, :fair_value]
                },
                incentive_sub_program: { include: :incentive_program }
            }),
            purchase_opportunities: purchase_opportunities_json(employee.purchase_opportunities),
            tenant: tenant,
            stockPrice: stock_price,
            features: tenant.feature,
            windows: user_service.user_windows,
            documents: documents
        }

        render json: { data: data}, status: :ok
      end

      def purchase_opportunities_json(purchase_opportunities)
        purchase_opportunities.map { |p|
          {
              id: p.id,
              documentId: p.document_id,
              maximumAmount: p.maximumAmount,
              purchasedAmount: p.purchasedAmount,
              showShareDepository: p.purchase_config.require_share_depository,
              price: p.purchase_config.price,
              instrument: p.purchase_config.incentive_sub_program.instrumentTypeId,
              windowId: p.purchase_config.window_id
          }
        }
      end
    end
  end
end
