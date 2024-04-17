# frozen_string_literal: true

class CreateRepositoryChecks < ActiveRecord::Migration[7.1]
  def change
    create_table :repository_checks do |t|
      t.string :commit_id
      t.references :repository, null: false, foreign_key: true
      t.string :aasm_state, null: false, default: 'request'
      t.json :details, default: {}

      t.timestamps
    end
  end
end
