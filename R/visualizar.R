#' Desenhar corte
#'
#' Desenha uma onda após realizar o corte, pintando cada letra identificada com
#' uma cor diferente.
#'
#' @param onda vetor de frequências retornado por \code{\link{ler_audio}}.
#'
#' @importFrom ggplot2 ggplot aes geom_line theme_bw
#' @export
#'
#' @examples
#' arq_aud <- system.file('audio.wav', package = 'captchaTJMGAudio')
#' onda <- ler_audio(arq_aud)
#' desenhar_corte(onda)
desenhar_corte <- function(onda) {
  onda %>%
    quebrar_letras() %>%
    ggplot(aes(x = tempo, y = som, colour = letra)) +
    geom_line() +
    theme_bw()
}

#' Desenha imagem
#'
#' Plota imagem na tela a partir de arquivo de imagem jpg.
#'
#' @param arq_img caminho da imagem jpg.
#'
#' @export
desenhar_img <- function(arq_img) {
  arq_img %>%
    magick::image_read() %>%
    plot()
}
