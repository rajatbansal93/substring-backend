# frozen_string_literal: true

# SubstringCalculation model
class SubstringCalculation < ActiveRecord::Base
  validates :main_string, :sub_string, :user, presence: true

  belongs_to :user

  before_save :calculate_sub_string

  private

  def calculate_sub_string
    counter = 0
    main_string.each_char do |char|
      counter += 1 if char == sub_string[counter]
      break if counter.eql? sub_string.length
    end
    self.result = counter.eql? sub_string.length
  end
end
