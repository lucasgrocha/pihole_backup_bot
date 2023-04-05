# frozen_string_literal: true

require 'telegram/bot'
require 'dotenv'

Dotenv.load('.env')

token = ENV['BOT_TOKEN']
BACKUP_PATH = ENV['BACKUP_PATH']
available_chat_ids = ENV['AVAILABLE_CHAT_IDS'].split(',')

filename_and_path = Dir.glob("#{BACKUP_PATH}/*.tar.gz").last

Telegram::Bot::Client.run(token, logger: Logger.new($stderr)) do |bot|
  bot.logger.info('Bot has been started')

  available_chat_ids.each do |chat_id|
    bot.api.send_message(chat_id:, text: "Hey, here's your pihole backup! 🍒")
    bot.api.send_document(chat_id:,
                          document: Faraday::UploadIO.new(filename_and_path,
                                                          'application/gzip-compressed-tar'))
  end
end
