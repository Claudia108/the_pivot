
class CreateUsersJobs < ActiveRecord::Migration
  def change
    create_table :users_jobs do |t|
      t.string :status
      t.text :resume
      t.references :user, index: true, foreign_key: true
      t.references :job, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
