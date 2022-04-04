import simulationStore from 'store/simulation'

describe('#add_params', () => {
  const mockDate = new Date('2022-03-15')
  jest.spyOn(global, 'Date').mockImplementation(() => mockDate)
  const simulation = simulationStore()

  it('add value at the end of params', () => {
    expect(simulation.params).toEqual({
      simulationDate: mockDate
    })

    const values = { employmentMonth: '2022/03' }
    simulation.add_params(values)
    expect(simulation.params).toEqual({
      simulationDate: mockDate,
      employmentMonth: '2022/03'
    })
  })
})

describe('#reset', () => {
  const mockDate = new Date('2022-03-15')
  jest.spyOn(global, 'Date').mockImplementation(() => mockDate)
  const simulation = simulationStore()

  it('reset params, result, routes and currentStep', () => {
    simulation.reset()
    expect(simulation.params).toEqual({ simulationDate: mockDate })
    expect(simulation.steps).toEqual(10)
    expect(simulation.currentStepIdx).toEqual(0)
  })
})
