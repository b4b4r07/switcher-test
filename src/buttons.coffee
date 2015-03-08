if Config.script
  if document.querySelectorAll
    anchors = document.querySelectorAll "a.#{Config.anchorClass}"
  else
    anchors =
      anchor for anchor in document.getElementsByTagName "a" when new Element(anchor).hasClass Config.anchorClass

  for anchor in anchors
    do (a = anchor) ->
      new ButtonFrame Hash.encode(ButtonAnchor.parse a), (iframe) ->
        a.parentNode.insertBefore iframe, a
        return
      , ->
        a.parentNode.removeChild a
        return
      return
else
  new ButtonFrameContent Hash.decode()
