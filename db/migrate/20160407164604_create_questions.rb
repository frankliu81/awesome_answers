# thisl file doesn't automatically create the table, it just defines how they
# table must be created.  To execute it you will need to run: bin/rake db:migrate
class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|

      # you don't need to exlicityly define the id field as it will be
      # added automatically.  Rails will add an 'id' field that is an integer
      # primary key with 'autoincrement'
      t.string :title
      t.text :body

      # timestamps will ad two extra fields: created_at and updated_at
      # they will be of type datetime
      # they will be automatically set by ActiveRecord
      t.timestamps null: false
    end
  end
end
