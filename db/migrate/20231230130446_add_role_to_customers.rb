class AddRoleToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :role, :string, default: 'customer'
  end
end
