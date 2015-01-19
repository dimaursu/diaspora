class AddVerificationCodesToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :phone,            :string
    add_column :profiles, :phone_v_code,     :string
    add_column :profiles, :phone_verified,   :boolean
  end
end
