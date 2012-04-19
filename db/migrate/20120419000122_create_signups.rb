class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.string :email
      t.integer :status
      t.timestamps
    end
    add_index :signups, :email
    add_index :signups, :status
    add_index :signups, :created_at
  end
end
