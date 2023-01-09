# frozen_string_literal: true

class BackgroundProcessesController < ApplicationController
  def index
    render(
      json: JobDatum.order(created_at: :desc).limit(50)
    )
  end
end
