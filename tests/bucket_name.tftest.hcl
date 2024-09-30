run "test_bucket_name_is_valid" {

    command = apply

    variables {
        environment = "dev"
        archivos = {
            "1.txt" = "Contenido 1"
            "2.txt" = "Contenido 2"
            "3.txt" = "Contenido 3"
        }
    }

    assert {
        condition = strcontains(aws_s3_bucket.bucket.bucket, "pedro-test-terraform-dev")
        error_message = "El nombre del bucket no es valido"
    }

    assert {
        condition = length(aws_s3_object.archivos) == 3
        error_message = "El número de archivos subidos es inválido"
    }

    assert {
        #alltrue(lista bools) Retorna true si todos los valores son true
        #anytrue(lista bools) Retorna true si algún valor es true

        #Quiero verificar que el nombre de todos los archivos subidos a s3
        #se corresponden con uno de los nombres de la variable archivos
        condition = alltrue([for s3_object in aws_s3_object.archivos: 
        anytrue([for var_key, var_value in var.archivos: s3_object.key == var_key])])
        error_message = "Los nombres de archivos generados no coinciden"
    }
}

run "bucket_prefix_is_valid" {
    command = plan

    variables {
        environment = "dev"
    }

    assert {
        condition = aws_s3_bucket.bucket.bucket_prefix == "pedro-test-terraform-dev"
        error_message = "El prefijo del bucket no es válido"
    }
}