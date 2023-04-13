class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :email_verified, :boolean
  end
end
