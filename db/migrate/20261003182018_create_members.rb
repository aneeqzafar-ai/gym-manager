class CreateMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :members do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.date :joined_on

      t.timestamps
    end
  end
end
