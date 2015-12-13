class RemoveFieldsFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :address
        remove_column :orders, :email
        remove_column :orders, :pay_type
      end


end
