class AddFieldsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :admire,           :string
    add_column :profiles, :locality,         :string
    add_column :profiles, :county,           :string
    add_column :profiles, :phone,            :integer
    add_column :profiles, :height,           :integer
    add_column :profiles, :weight,           :integer
    add_column :profiles, :smoking,          :boolean
    add_column :profiles, :profession,       :string
    add_column :profiles, :education,        :string
    add_column :profiles, :civil_status,     :string
    add_column :profiles, :childrens,        :integer
    add_column :profiles, :constitution,     :string
    add_column :profiles, :eye_color,        :string
    add_column :profiles, :hair_color,       :string
    add_column :profiles, :strengths,        :text
    add_column :profiles, :activation_code,  :integer
    add_column :profiles, :visibility,       :boolean
  end
end
