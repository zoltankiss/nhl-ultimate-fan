# frozen_string_literal: true

class FunFact < ApplicationRecord
  belongs_to :fun_factable, polymorphic: true
end
