class CreateConversationMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :conversation_messages do |t|
      t.text :content
      t.boolean :is_read, default: false
      
      t.references :user, null: false, foreign_key: true
      t.references :conversation, null: false, foreign_key: true
      t.timestamps
    end
  end
end
