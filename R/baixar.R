#' Baixar uma imagem e um audio
#'
#' Baixa uma imagem JPG e um audio WAV no caminho especificado.
#'
#' @param dir diretório onde os arquivos serão salvos. O nome do arquivo é um
#'   timestamp. A imagem e o áudio contém o mesmo CAPTCHA.
#'
#' @export
baixar_img_audio <- function(dir = "data-raw/captcha") {
  if (!file.exists(dir)) dir.create(dir, recursive = TRUE)
  url_pesq <- 'http://www4.tjmg.jus.br/juridico/sf/proc_resultado.jsp?tipoPesquisa=1&comrCodigo=701&txtProcesso=02775087620168130701&listaProcessos=02775087620168130701&nomePessoa=Nome+da+Pessoa&tipoPessoa=X&naturezaProcesso=0&situacaoParte=X&codigoOAB=&tipoOAB=N&ufOAB=MG&tipoConsulta=1&natureza=0&ativoBaixado=X&numero=1&select=1'
  url_img <- 'http://www4.tjmg.jus.br/juridico/sf/captcha.svl'
  url_aud <- 'http://www4.tjmg.jus.br/juridico/sf/captchaAudio.svl'
  r0 <- httr::GET(url_pesq)
  data_hora <- stringr::str_replace_all(lubridate::now(), "[^0-9]", "")
  arq <- tempfile(pattern = data_hora, tmpdir = dir)
  wd_img <- httr::write_disk(paste0(arq, ".jpg"), overwrite = TRUE)
  wd_aud <- httr::write_disk(paste0(arq, ".wav"), overwrite = TRUE)
  r_img <- httr::GET(url_img, wd_img)
  r_aud <- httr::GET(url_aud, wd_aud)
}

#' Baixar várias imagens e vários áudios
#'
#' Baixa imagens JPG e áudios WAV no caminho especificado.
#'
#' @param nlim quantidade de captchas a serem baixados. Default 1000.
#' @param esperar quantidade de segundos para esperar entre requisições. Default
#'   0.0.
#' @param dir diretório onde os arquivos serão salvos. O nome do arquivo é um
#'   timestamp. Default "data-raw/captcha".
#' @param verbose imprimir mensagens com o andamento dos downloads?
#'
#' @export
baixar_imgs_audios <- function (nlim = 1000L,
                                esperar = 0.0,
                                dir = "data-raw/captcha",
                                verbose = TRUE) {
  for (i in 1:nlim) {
    baixar_img_audio(dir)
    Sys.sleep(esperar)
    if (verbose) cat(i, "de", nlim, "\n")
  }
}
