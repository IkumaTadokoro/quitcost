import { shallowMount } from '@vue/test-utils'
import InsuranceCompleteButton from 'components/simulation_form/InsuranceCompleteButton'

describe('InsuranceCompleteButton', () => {
  describe('emit', () => {
    describe('when InsuranceCompleteButton is clicked', () => {
      describe('when props:salary is 0', () => {
        it('fires completeInsurance event with insurance: 0', async () => {
          const wrapper = shallowMount(InsuranceCompleteButton, {
            props: {
              salary: 0
            }
          })

          await wrapper
            .get(`[data-test-id="completeInsuranceButton"]`)
            .trigger('click')

          const emit = wrapper.emitted()

          expect(emit).toHaveProperty('completeInsurance')

          expect(emit['completeInsurance'][0]).toEqual([0])
        })
      })

      describe('when props:salary is NOT 0', () => {
        it('fires completeInsurance event with insurance which is 15% of the salary rounded down to the nearest 100 yen', async () => {
          const wrapper = shallowMount(InsuranceCompleteButton, {
            props: {
              salary: 4578921
            }
          })

          await wrapper
            .get(`[data-test-id="completeInsuranceButton"]`)
            .trigger('click')

          const emit = wrapper.emitted()

          expect(emit).toHaveProperty('completeInsurance')

          // 4578921 * 15% = 686831.15
          expect(emit['completeInsurance'][0]).toEqual([686800])
        })
      })
    })
  })
})
