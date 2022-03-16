import Swal from 'sweetalert2'

export const useToast = () => {
  const toast = (title) => {
    Swal.fire({
      title: title,
      toast: true,
      position: 'top-end',
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true
    })
  }

  return { toast }
}
