Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      resources :tenants, :countries, :entities, :employees, :incentive_programs, :welcomes, :stock_prices,
                :files, :features, :exercise_order, :exercise_windows, :health_check, :texts, :download,
                :documents, :configs, :windows, :orders, :content_templates, :purchase_opportunity, :dividends,
                :transactions
      resources :incentive_programs do
        resources :sub_programs
      end
      resources :sub_programs do
        resources :awards
        resources :purchase_config
      end

      resources :purchase_config do
        resources :purchase_opportunity
      end

      resources :awards do
        collection do
          get 'all_awards'
        end
      end
      resources :employee_documents do
        member do
          post 'read'
        end
      end

      resources :tenants do
        member do
          put 'update_config'
          put 'update_default_config'
        end
      end

      resources :employees do
        member do
          post 'termination'
        end
      end

      #namespace ':tenantId' do
        #resources :entity
      #end
    end
  end
end
