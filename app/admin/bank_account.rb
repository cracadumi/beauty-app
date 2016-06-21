ActiveAdmin.register BankAccount do
  permit_params :settings_beautician_id, :bank_code, :branch_number,
                :account_number, :rib_key, :iban, :bic, :account_holder_name

  index do
    selectable_column
    id_column
    column :settings_beautician
    column :account_number
    column :account_holder_name
    actions
  end

  filter :settings_beautician
  filter :account_number
  filter :account_holder_name

  form do |f|
    f.inputs 'BankAccount Details' do
      f.semantic_errors(*f.object.errors.keys)
      f.input :settings_beautician
      f.input :bank_code
      f.input :branch_number
      f.input :account_number
      f.input :rib_key
      f.input :iban
      f.input :bic
      f.input :account_holder_name
    end
    f.actions
  end
end
