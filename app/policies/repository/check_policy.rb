# frozen_string_literal: true

module Repository
  class CheckPolicy < ApplicationPolicy
    def show?
      user == record.repository.user
    end

    def create?
      user == record.repository.user
    end
  end
end