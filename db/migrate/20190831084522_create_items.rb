class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :item_name
      t.string :from_shop
      t.integer :now_price
      t.integer :ori_price
      t.string :url
      
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end


