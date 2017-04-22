#' Carrega o sinal .wav no R.
#'
#' @param arq_aud caminho/do/audio/do/captcha.wav ou objeto do tipo response.
#'
#' @export
ler_audio <- function(arq_aud) {
  arq_aud <- arquivo(arq_aud)
  tuneR::readWave(arq_aud)@left
}

#' Pegar caminho do arquivo
#'
#' @param x caminho/do/audio/do/captcha.wav ou objeto do tipo response.
#'
#' @export
arquivo <- function(x) {
  UseMethod('arquivo')
}

arquivo.response <- function(x) {
  arq <- x$request$output$path
  if (!file.exists(arq)) stop('Arquivo n\032o encontrado.')
  arq
}

arquivo.character <- function(x) {
  if (!file.exists(x)) stop('Arquivo n\032o encontrado.')
  x
}

