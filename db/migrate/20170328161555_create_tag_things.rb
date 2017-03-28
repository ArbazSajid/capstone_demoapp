class CreateTagThings < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :value
      t.integer :creator_id, {null:false}

      t.timestamps null: false
    end
    add_index :tags, :creator_id

    create_table :tag_things do |t|
      t.references :tag, {index: true, foreign_key: true, null:false}
      t.references :thing, {index: true, foreign_key: true, null:false}
      t.integer :creator_id, {null:false}

      t.timestamps null: false
    end

    add_index :tag_things, [:tag_id, :thing_id], unique:true

  end
end
