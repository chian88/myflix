class AddTokenForInvitations < ActiveRecord::Migration
  def change
  	add_column :invitations, :token, :string
  end
end
