mais_perto <- function(d, soma) {
  d$letra[which.min((d$soma - soma) ^ 2)][1]
}

#' Prediz as letras a partir do audio
#'
#' Recebe o caminho do áudio e retorna cinco números colados em um character
#' vector. Os números são obtidos a partir de uma tabela pré classificada das
#' somas das frequências de cada letra.
#'
#' @param arq_aud caminho/do/audio/do/captcha.wav ou objeto do tipo response.
#'
#' @export
#'
#' @examples
#' arq_aud <- system.file('audio.wav', package = 'captchaTJMGAudio')
#' predizer(arq_aud)
#' # [1] "99182"
predizer <- function(arq_aud) {
  d <- tibble::tribble(
    ~letra, ~soma,
    '0',  319372, #
    '1', -254408, #
    '2', -357682, #
    '3', -432247, #
    '4', -1589284,#
    '5',  93434,  #
    '6', -513914, #
    '7',  274265, #
    '8', -363110, #
    '9',  87392   #
  )
  arq_aud %>%
    tabelar_letras() %>%
    dplyr::mutate(res = purrr::map_chr(soma, ~mais_perto(d, .x))) %>%
    with(res) %>%
    glue::collapse()
}
