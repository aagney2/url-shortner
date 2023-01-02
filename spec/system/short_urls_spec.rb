# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'

# WebDrivers Gem
# https://github.com/titusfortner/webdrivers
#
# Official Guides about System Testing
# https://api.rubyonrails.org/v5.2/classes/ActionDispatch/SystemTestCase.html

RSpec.describe 'Short Urls', type: :system do
  before do
    driven_by :selenium, using: :chrome
    # If using Firefox
    # driven_by :selenium, using: :firefox
    #
    # If running on a virtual machine or similar that does not have a UI, use
    # a headless driver
    # driven_by :selenium, using: :headless_chrome
    # driven_by :selenium, using: :headless_firefox
  end

  describe 'index' do
    it 'shows a list of short urls' do
      7.times {FactoryBot.create(:url)}
      visit root_path
      expect(page).to have_text('HeyURL!')
      expect(page).to have_selector('table tbody tr', count:10)
    end
  end

  describe 'show' do
    it 'shows a panel of stats for a given short url' do
      url_record = FactoryBot.create(:url)
      visit url_path(url_record.short_url)
      expect(page).to have_text(url_record.short_url)
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit url_path('NOTFOUND')
        # expect page to be a 404
        expect(page).to have_text("The page you were looking for doesn't exist.")
      end
    end
  end

  describe 'create' do
    context 'when url is valid' do
      it 'creates the short url' do
        url_record = FactoryBot.create(:url)
        visit urls_path
        expect(page).to have_text(url_record.original_url)
        expect(page).to have_text(url_record.short_url)
        # add more expections
      end

      it 'redirects to the home page' do
        visit '/'
        # fill the original url field
        fill_in 'url_original_url', with: 'https://github.com/hashwin/o3-utils/branches'
        # submit the form
        click_button 'Shorten URL'
        expect(page).to have_current_path('/')
        # expect(page).to have_text("Url was successfully created")
        # add more expections
      end
    end

    context 'when url is invalid' do
      it 'does not create the short url and shows a message' do
        visit '/'
        # add more expections
      end

      it 'redirects to the home page' do
        visit '/'
        # add more expections
      end
    end
  end

  describe 'visit' do
    it 'redirects the user to the original url' do
      visit visit_path('ABCDE')
      # add more expections
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit visit_path('NOTFOUND')
        # expect page to be a 404
      end
    end
  end
end
