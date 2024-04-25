class ChangeDefaultValueInRepositoryCheck < ActiveRecord::Migration[7.1]
  def change
    change_column_default :repository_checks, :aasm_state, 'created'
  end
end
