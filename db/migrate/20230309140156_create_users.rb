class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :preferred_username
      t.string :aud
      t.string :exp
      t.string :iat
      t.string :iss
      t.string :sub
      t.string :jti
      t.string :authenticationType
      t.string :auth_time
      t.string :tid

      t.timestamps
    end
  end
end
