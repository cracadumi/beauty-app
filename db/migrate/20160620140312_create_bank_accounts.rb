class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.references :settings_beautician, index: true
      t.integer :bank_code
      t.integer :branch_number
      t.integer :account_number
      t.integer :rib_key
      t.integer :iban
      t.integer :bic
      t.string :account_holder_name

      t.timestamps null: false
    end
  end
end
