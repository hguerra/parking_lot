class CreateParkings < ActiveRecord::Migration[6.0]
  def change
    create_table :parking do |t|
      t.string :plate, null: false
      t.string :time
      t.boolean :paid, null: false, default: false
      t.boolean :left, null: false, default: false
      t.datetime :entry_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :left_at

      t.timestamps
    end
  end
end
