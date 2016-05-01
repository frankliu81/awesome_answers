class AddOmniauthFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    # for oauth, we will be doing many queries selecting a user
    # by the combination of its uid and provider
    add_index :users, [:uid, :provider]
  end
end
