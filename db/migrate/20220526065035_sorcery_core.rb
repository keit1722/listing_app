class SorceryCore < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :crypted_password
      t.string :salt
      t.string 'first_name', null: false
      t.string 'last_name', null: false
      t.string 'username', null: false, index: { unique: true }
      t.integer 'role', null: false, default: 1
      t.string :public_uid, index: { unique: true }

      t.timestamps null: false
    end
  end
end