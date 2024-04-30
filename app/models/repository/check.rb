# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_checks
#
#  id            :integer          not null, primary key
#  aasm_state    :string           default("created"), not null
#  details       :json
#  passed        :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  commit_id     :string
#  repository_id :integer          not null
#
# Indexes
#
#  index_repository_checks_on_repository_id  (repository_id)
#
# Foreign Keys
#
#  repository_id  (repository_id => repositories.id)
#
class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  aasm do
    state :created, initial: true
    state :requested, :finished, :failed

    event :run_check do
      transitions from: :created, to: :requested
    end

    event :finish do
      transitions from: :requested, to: :finished
    end

    event :fail do
      transitions from: :requested, to: :failed
    end
  end
end
