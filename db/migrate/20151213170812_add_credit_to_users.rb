class AddCreditToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit, :decimal
  end
end
