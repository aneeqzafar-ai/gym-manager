class CreateMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :memberships do |t|
      t.references :member, null: false, foreign_key: true
      t.decimal :amount
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
