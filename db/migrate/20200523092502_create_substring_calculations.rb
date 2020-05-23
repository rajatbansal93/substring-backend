class CreateSubstringCalculations < ActiveRecord::Migration[6.0]
  def change
    create_table :substring_calculations do |t|
      t.string :main_string, defualt: ''
      t.string :sub_string, defualt: ''
      t.boolean :result, defualt: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
