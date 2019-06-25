require "/scripts/util.lua"
require "/quests/bounty/bounty_portraits.lua"

function init()
    setText()

    local params = quest.parameters()

    setBountyPortraits()

    quest.setPortrait("Objetivo", params.portraits.target)
    quest.setPortraitTitle("Objetivo", params.text.tags.bounty.name)
end

function questStart()
    quest.complete()
end

function setText()
  local tags = util.generateTextTags(quest.parameters().text.tags)
  quest.setTitle(sb.replaceTags("^orange;Recompensa: ^green;<bounty.name>", tags))

  local textCons
  for i, q in pairs(quest.questArcDescriptor().quests) do
    local questConfig = root.questConfig(q.templateId).scriptConfig
    local text = ""
    if i > 1 then
      text = util.randomFromList(questConfig.generatedText.text.prev or questConfig.generatedText.text.default)
    else
      text = util.randomFromList(questConfig.generatedText.text.default)
    end

    local tags = util.generateTextTags(q.parameters.text.tags)
    if textCons then
      textCons = string.format("%s\n\n%s", textCons, sb.replaceTags(text, tags))
    else
      textCons = sb.replaceTags(text, tags)
    end
    if q.questId == quest.questId() then
      if questConfig.generatedText.failureText then
        local failureText = util.randomFromList(questConfig.generatedText.failureText.default)
        failureText = sb.replaceTags(failureText, tags)
        quest.setFailureText(failureText)
      end

      break
    end
  end

  quest.setText(textCons)
end
