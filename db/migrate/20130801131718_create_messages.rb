class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text    :text
      t.text    :subject
      t.integer     :user_id

      t.timestamps
    end
  end
end
