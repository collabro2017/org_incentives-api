class AddGrantTransactions < ActiveRecord::Migration[5.1]
  def change
    ActiveRecord::Base.transaction do
      #
      # Brukt for å merge data i produksjon. Ikke behov for i test eller lokalt.
      # Var nødvendig siden alle migrasjoner ble kjørt samtidig i produksjon. Opprettelsen av grant transactions
      # skjedde på samme tidspunkt som kodeendringene til VestingEvent, og dermed var det transaksjonene som ble brukt som
      # kopieringsgrunnlag.
      #
      # Transaction.destroy_all
      # VestingEvent.all.each {|vesting_event|
      #   vesting_event.transactions.create!(
      #       transaction_type: "GRANT",
      #       transaction_date: vesting_event.grant_date,
      #       grant_date: vesting_event.grant_date,
      #       vested_date: vesting_event.vestedDate,
      #       expiry_date: vesting_event.expiry_date,
      #       quantity: vesting_event.quantity,
      #       purchase_price: vesting_event.purchase_price,
      #       strike: vesting_event.strike
      #   )
      # }
    end
  end
end
