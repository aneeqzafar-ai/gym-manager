class CreateClassEnrollments < ActiveRecord::Migration[8.1]
  def change
    create_table :class_enrollments do |t|
      t.references :member, null: false, foreign_key: true
      t.references :gym_class, null: false, foreign_key: true

      t.timestamps
    end
  end
end
