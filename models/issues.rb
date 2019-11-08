# frozen_string_literal: true

require 'date'

# Issues data model
class Issue < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :turnaround
  validates_presence_of :submit_date

  validate :submit

  def not_work_hours(date = submit_date)
    date.saturday? ||
      date.sunday?  ||
      date.hour < 9 ||
      date.hour > 17
  end

  def calculate_due_date
    due_date = submit_date
    day_spend = turnaround / 8
    hour_spend = (turnaround % 8).ceil

    day_spend.times do
      due_date += 2.day if not_work_hours(due_date + 1.day)
      due_date += 1.day
    end

    hour_spend.times do
      due_date += 16.hours if not_work_hours(due_date + 1.hour)
      due_date += 1.hour
    end
    due_date
  end

  private

  def submit
    errors.add('Out of work hours') if not_work_hours
  end
end
